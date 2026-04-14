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
$format = 'best/bestvideo*+bestaudio'

# 字幕选项 下载字幕并合并到视频
$subtile = @('--write-subs', '--write-auto-subs', '--sub-langs', 'en.*,zh.*', '--convert-subs', 'ass')

Write-Host "🚀 正在下载最高画质视频..." -ForegroundColor Cyan
yt-dlp --cookies-from-browser chrome --external-downloader aria2c --external-downloader-args "-x 16 -s 16 -k 1M -c" --no-check-certificate --compat-options no-youtube-unavailable-videos $subtile -f $format -o "%(title)s.%(ext)s" --embed-metadata $Url

if ($LASTEXITCODE -eq 0)
{
    Write-Host "`n✅ 下载完成！" -ForegroundColor Green
}
else
{
    Write-Host "`n❌ 下载失败，请检查视频链接或 cookies 状态。" -ForegroundColor Red
}
