Param()

[void][Reflection.Assembly]::LoadWithPartialName('System.Drawing')
$src = "assets/images/blog-selected.jpg"
if (-not (Test-Path $src)) {
	Write-Host "Source image not found: $src"
	exit 0
}

$img = [System.Drawing.Image]::FromFile($src)
function Resize-Save([int]$width, [string]$out) {
	$ratio = $img.Height / $img.Width
	$height = [int]($width * $ratio)
	$bmp = New-Object System.Drawing.Bitmap $width, $height
	$g = [System.Drawing.Graphics]::FromImage($bmp)
	$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
	$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
	$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
	$g.DrawImage($img, 0, 0, $width, $height)
	$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
	$eps = New-Object System.Drawing.Imaging.EncoderParameters(1)
	$eps.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 85)
	[System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($out)) | Out-Null
	$bmp.Save($out, $enc, $eps)
	$g.Dispose()
	$bmp.Dispose()
	Write-Host "Saved $out"
}

Resize-Save -width 1200 -out "assets/images/blog-selected-large.jpg"
Resize-Save -width 480 -out "assets/images/blog-selected-small.jpg"
$img.Dispose()
Write-Host "Resizing complete."
