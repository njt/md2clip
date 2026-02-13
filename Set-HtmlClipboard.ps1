# Set-HtmlClipboard.ps1
# Reads an HTML file and sets the Windows clipboard with CF_HTML format.
# Must be called with: powershell.exe -STA -NoProfile -File Set-HtmlClipboard.ps1 -Path <file>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

Add-Type -AssemblyName System.Windows.Forms

$html = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)

# Build the CF_HTML clipboard format
$prefix = "<html><body>`r`n<!--StartFragment-->"
$suffix = "<!--EndFragment-->`r`n</body></html>"

$headerTemplate = "Version:0.9`r`nStartHTML:{0:D10}`r`nEndHTML:{1:D10}`r`nStartFragment:{2:D10}`r`nEndFragment:{3:D10}`r`n"

# Calculate byte offsets with a dummy header to get stable size
$dummyHeader = [string]::Format($headerTemplate, 0, 0, 0, 0)
$enc = [System.Text.Encoding]::UTF8

$headerLen   = $enc.GetByteCount($dummyHeader)
$prefixLen   = $enc.GetByteCount($prefix)
$htmlLen     = $enc.GetByteCount($html)
$suffixLen   = $enc.GetByteCount($suffix)

$startHtml     = $headerLen
$startFragment = $startHtml + $prefixLen
$endFragment   = $startFragment + $htmlLen
$endHtml       = $endFragment + $suffixLen

$header = [string]::Format($headerTemplate, $startHtml, $endHtml, $startFragment, $endFragment)
$cfHtml = $header + $prefix + $html + $suffix

# Pass as UTF-8 MemoryStream, not string — .NET re-encodes strings and mangles Unicode
$bytes = [System.Text.Encoding]::UTF8.GetBytes($cfHtml)
$stream = New-Object System.IO.MemoryStream(,$bytes)

$dataObject = New-Object System.Windows.Forms.DataObject
$dataObject.SetData([System.Windows.Forms.DataFormats]::Html, $stream)
$dataObject.SetData([System.Windows.Forms.DataFormats]::UnicodeText, $html)
[System.Windows.Forms.Clipboard]::SetDataObject($dataObject, $true)

Write-Host "Rich text copied to clipboard."
