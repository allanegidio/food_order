defmodule FoodOrderWeb.Admin.ProductLive.ImageUploadConfig do
  alias FoodOrderWeb.Utils.SimpleS3Upload

  def upload_options do
    get_allow_options(Mix.env())
  end

  def get_allow_options(:local) do
    [accept: ~w/.png .jpeg .jpg/, max_entries: 1]
  end

  def get_allow_options(:s3) do
    [accept: ~w/.png .jpeg .jpg/, max_entries: 1, external: &s3_metadata/2]
  end

  defp s3_metadata(entry, socket) do
    uploads = socket.assigns.uploads
    bucket = System.fetch_env!("AWS_BUCKET")
    key = file_name(entry)

    config = %{
      region: System.fetch_env!("AWS_REGION"),
      access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
      secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY")
    }

    {:ok, fields} =
      SimpleS3Upload.sign_form_upload(config, bucket,
        key: key,
        content_type: entry.client_type,
        max_file_size: uploads[entry.upload_config].max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{
      uploader: "S3",
      key: key,
      url: s3_url(),
      fields: fields
    }

    {:ok, meta, socket}
  end

  def get_image_url(entry) do
    if System.get_env("PROD") == nil do
      "/uploads/#{file_name(entry)}"
    else
      Path.join(s3_url(), file_name(entry))
    end
  end

  def consume_entries(meta, entry) do
    if System.get_env("PROD") == nil do
      file_name = file_name(entry)
      dest = Path.join("priv/static/uploads", file_name)

      {:ok, File.cp!(meta.path, dest)}
    else
      {:ok, ""}
    end
  end

  defp s3_url do
    bucket = System.fetch_env!("AWS_BUCKET")
    region = System.fetch_env!("AWS_REGION")
    "http://#{bucket}.s3-#{region}.amazonaws.com"
  end

  defp file_name(entry) do
    [ext | _] = MIME.extensions(entry.client_type)

    "#{entry.uuid}.#{ext}"
  end
end
