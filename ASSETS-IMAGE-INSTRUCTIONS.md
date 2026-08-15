Download and install selected thumbnails

The site expects three thumbnail files in the repository at these paths:

- assets/images/blog-selected.jpg
- assets/images/tools-selected.jpg
- assets/images/software-selected.jpg

You can download the images from the following source pages (chosen by you):

1) Blog (Pexels): https://www.pexels.com/photo/creek-in-park-6674897/
2) Tools (Unsplash illustration): https://unsplash.com/illustrations/tools-and-hardware-are-depicted-in-this-image-UXXIDcnmUAc
3) Software (Unsplash photo): https://unsplash.com/photos/a-blue-abstract-background-with-lines-and-dots-pREq0ns_p_E

PowerShell helper (run in project root) — attempts to find the 'og:image' meta tag and download it:

```
function Download-ImageFromPage($url, $out) {
  $html = (Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop).Content
  if ($html -match '<meta property="og:image" content="([^"]+)"') {
	$img = $matches[1]
	Invoke-WebRequest -Uri $img -OutFile $out -UseBasicParsing
	Write-Host "Saved $out"
  } else {
	Write-Host "Could not find og:image for $url. Open the page and download manually."
  }
}

# Examples (run one at a time):
Download-ImageFromPage 'https://www.pexels.com/photo/creek-in-park-6674897/' '.\assets\images\blog-selected.jpg'
Download-ImageFromPage 'https://unsplash.com/illustrations/tools-and-hardware-are-depicted-in-this-image-UXXIDcnmUAc' '.\assets\images\tools-selected.jpg'
Download-ImageFromPage 'https://unsplash.com/photos/a-blue-abstract-background-with-lines-and-dots-pREq0ns_p_E' '.\assets\images\software-selected.jpg'

If the helper fails due to bot protection, open each source URL in your browser, download the image, and save it to the paths above. Unsplash and Pexels generally permit free use but check license and credit requirements. For Unsplash, attribution is appreciated: photographer name and Unsplash link.
