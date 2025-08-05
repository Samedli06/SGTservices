Add-Type -AssemblyName System.Drawing

# Load the original image
$originalImage = [System.Drawing.Image]::FromFile("logo_header.png")

# Create a new bitmap with the desired size (200x45 pixels)
$newWidth = 200
$newHeight = 45
$resizedImage = New-Object System.Drawing.Bitmap($newWidth, $newHeight)

# Create graphics object for drawing
$graphics = [System.Drawing.Graphics]::FromImage($resizedImage)

# Set high quality interpolation
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Calculate scaling to maintain aspect ratio
$scaleX = $newWidth / $originalImage.Width
$scaleY = $newHeight / $originalImage.Height
$scale = [Math]::Min($scaleX, $scaleY)

$scaledWidth = [int]($originalImage.Width * $scale)
$scaledHeight = [int]($originalImage.Height * $scale)

# Calculate centering offsets
$offsetX = ($newWidth - $scaledWidth) / 2
$offsetY = ($newHeight - $scaledHeight) / 2

# Draw the resized image
$graphics.DrawImage($originalImage, $offsetX, $offsetY, $scaledWidth, $scaledHeight)

# Save the resized image
$resizedImage.Save("logo_header_small.png", [System.Drawing.Imaging.ImageFormat]::Png)

# Clean up
$graphics.Dispose()
$resizedImage.Dispose()
$originalImage.Dispose()

Write-Host "Logo resized successfully to logo_header_small.png" 