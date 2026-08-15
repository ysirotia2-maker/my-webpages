param(
	[string]$OutPath = "assets/audio/ambient.wav",
	[int]$SampleRate = 22050,
	[int]$Seconds = 2
)

$bytesPerSample = 2
$numSamples = $SampleRate * $Seconds
$dataSize = $numSamples * $bytesPerSample
$riffSize = 36 + $dataSize

$ms = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter($ms)

# RIFF header
$bw.Write([System.Text.Encoding]::ASCII.GetBytes('RIFF'))
$bw.Write([int]$riffSize)
$bw.Write([System.Text.Encoding]::ASCII.GetBytes('WAVE'))

# fmt chunk
$bw.Write([System.Text.Encoding]::ASCII.GetBytes('fmt '))
$bw.Write([int]16)                    # Subchunk1Size for PCM
$bw.Write([short]1)                   # AudioFormat PCM
$bw.Write([short]1)                   # NumChannels
$bw.Write([int]$SampleRate)          # SampleRate
$bw.Write([int]($SampleRate * $bytesPerSample)) # ByteRate
$bw.Write([short]($bytesPerSample))   # BlockAlign
$bw.Write([short]16)                  # BitsPerSample

# data chunk
$bw.Write([System.Text.Encoding]::ASCII.GetBytes('data'))
$bw.Write([int]$dataSize)

# write silence samples (zeros)
for($i=0; $i -lt $numSamples; $i++){
	$bw.Write([short]0)
}

$bw.Flush()

[System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($OutPath)) | Out-Null
[System.IO.File]::WriteAllBytes($OutPath, $ms.ToArray())
Write-Host "Created silent WAV: $OutPath ($Seconds s @ $SampleRate Hz)"
