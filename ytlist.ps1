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

# 字幕选项 下载字幕并合并到视频
$subtile = @('--embed-subs', '--write-subs', '--write-auto-subs', '--convert-subs', 'ass')

# 脚本工作目录
$cwd = $PWD.Path

Write-Host "🚀 正在下载最高画质视频..." -ForegroundColor Cyan

# %(autonumber)03d - 指定序号格式为 001 002 003 ..
yt-dlp --yes-playlist --playlist-reverse -o "$cwd\%(playlist_title)s\%(autonumber)d.%(title)s.%(ext)s" -I "1:" --cookies-from-browser chrome --no-check-certificate --compat-options no-youtube-unavailable-videos -f best/bestvideo*+bestaudio $subtile --embed-metadata $Url

if ($LASTEXITCODE -eq 0)
{
    Write-Host "`n✅ 下载完成！" -ForegroundColor Green
}
else
{
    Write-Host "`n❌ 下载失败，请检查视频链接或 cookies 状态。" -ForegroundColor Red
}
