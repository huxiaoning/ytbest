param(
    [Parameter(Mandatory = $true)]
    [string]$Url
)

# 检查是否安装 yt-dlp
if (-not (Get-Command yt-dlp -ErrorAction SilentlyContinue))
{
    Write-Host "❌ 未检测到 yt-dlp，请先安装：" -ForegroundColor Red
    Write-Host "scoop install yt-dlp   或   pip install yt-dlp" -ForegroundColor Yellow
    exit 1
}

# 检查是否安装 ffmpeg
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue))
{
    Write-Host "❌ 未检测到 ffmpeg，请先安装：" -ForegroundColor Red
    Write-Host "scoop install ffmpeg   或   choco install ffmpeg" -ForegroundColor Yellow
    exit 1
}

# 下载命令（优先 avc mp4 + m4a）
$format = 'bestvideo[ext=mp4][vcodec^=avc]+bestaudio[ext=m4a]/bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio/best[ext=mp4]/best'

Write-Host "🚀 正在下载最高画质视频..." -ForegroundColor Cyan
yt-dlp --cookies-from-browser chrome -f $format -o "%(title)s.%(ext)s" $Url

if ($LASTEXITCODE -eq 0)
{
    Write-Host "`n✅ 下载完成！" -ForegroundColor Green
}
else
{
    Write-Host "`n❌ 下载失败，请检查视频链接或 cookies 状态。" -ForegroundColor Red
}
