$port = 8765
$root = $PSScriptRoot
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Serving $root at http://localhost:$port/"
while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    try {
        $path = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath)
        if ($path -eq '/') { $path = '/index.html' }
        $file = Join-Path $root $path.TrimStart('/')
        if (Test-Path -LiteralPath $file -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($file)
            $ext = [System.IO.Path]::GetExtension($file).ToLower()
            $mime = switch ($ext) {
                '.html' { 'text/html' }
                '.css'  { 'text/css' }
                '.js'   { 'application/javascript' }
                '.png'  { 'image/png' }
                '.jpg'  { 'image/jpeg' }
                '.gif'  { 'image/gif' }
                '.svg'  { 'image/svg+xml' }
                '.mp3'  { 'audio/mpeg' }
                '.webm' { 'video/webm' }
                default { 'application/octet-stream' }
            }
            $ctx.Response.ContentType = $mime
            $ctx.Response.Headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
            $ctx.Response.Headers["Pragma"] = "no-cache"
            $ctx.Response.Headers["Expires"] = "0"
            $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        }
        else {
            $ctx.Response.StatusCode = 404
        }
    }
    catch {}
    $ctx.Response.Close()
}
