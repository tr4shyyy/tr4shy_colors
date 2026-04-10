$esc = [char]27

function Set-Style {
    param(
        [string]$fg,
        [string]$bg
    )

    $codes = @()
    if ($fg) {
        $r = [Convert]::ToInt32($fg.Substring(1, 2), 16)
        $g = [Convert]::ToInt32($fg.Substring(3, 2), 16)
        $b = [Convert]::ToInt32($fg.Substring(5, 2), 16)
        $codes += "38;2;$r;$g;$b"
    }
    if ($bg) {
        $r = [Convert]::ToInt32($bg.Substring(1, 2), 16)
        $g = [Convert]::ToInt32($bg.Substring(3, 2), 16)
        $b = [Convert]::ToInt32($bg.Substring(5, 2), 16)
        $codes += "48;2;$r;$g;$b"
    }

    if ($codes.Count -eq 0) {
        return ""
    }

    return "$esc[$($codes -join ';')m"
}

function Reset-Style {
    return "$esc[0m"
}

function Paint {
    param(
        [string]$text,
        [string]$fg,
        [string]$bg
    )

    return "$(Set-Style -fg $fg -bg $bg)$text$(Reset-Style)"
}

$palette = [ordered]@{
    background = '#181825'
    foreground = '#F9F9F9'
    comment = '#5C6780'
    keyword = '#CF8EF4'
    string = '#2BE491'
    number = '#FFC849'
    function = '#63C5EA'
    type = '#89E3F7'
    tag = '#FA5AA4'
    invalidFg = '#181825'
    invalidBg = '#FA5AA4'
    added = '#15E98A'
    removed = '#F63D92'
    gutter = '#16161D'
    accent = '#63C5EA'
}

Write-Host ""
Write-Host (Paint " tr4shy_colors Codex preview " $palette.background $palette.accent)
Write-Host ""
Write-Host "Palette swatches:"

foreach ($entry in $palette.GetEnumerator()) {
    $chip = Paint "  $($entry.Value)  " $palette.background $entry.Value
    Write-Host ("  " + $entry.Key.PadRight(10) + " " + $chip)
}

Write-Host ""
Write-Host "Syntax sample:"
Write-Host ""

$gutterStyle = Set-Style -fg $palette.comment -bg $palette.gutter
$baseStyle = Set-Style -fg $palette.foreground -bg $palette.background
$reset = Reset-Style

$lines = @(
    @(
        @{ text = " 1 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "// pastel-neon codex preview"; fg = $palette.comment; bg = $palette.background }
    ),
    @(
        @{ text = " 2 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "type"; fg = $palette.keyword; bg = $palette.background },
        @{ text = " "; fg = $palette.foreground; bg = $palette.background },
        @{ text = "ThemeName"; fg = $palette.type; bg = $palette.background },
        @{ text = " = "; fg = $palette.foreground; bg = $palette.background },
        @{ text = '"tr4shy_colors"'; fg = $palette.string; bg = $palette.background }
    ),
    @(
        @{ text = " 3 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "const"; fg = $palette.keyword; bg = $palette.background },
        @{ text = " "; fg = $palette.foreground; bg = $palette.background },
        @{ text = "accent"; fg = $palette.foreground; bg = $palette.background },
        @{ text = " = "; fg = $palette.foreground; bg = $palette.background },
        @{ text = '"#63C5EA"'; fg = $palette.string; bg = $palette.background }
    ),
    @(
        @{ text = " 4 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "function"; fg = $palette.keyword; bg = $palette.background },
        @{ text = " "; fg = $palette.foreground; bg = $palette.background },
        @{ text = "renderPreview"; fg = $palette.function; bg = $palette.background },
        @{ text = "("; fg = $palette.foreground; bg = $palette.background },
        @{ text = "count"; fg = $palette.foreground; bg = $palette.background },
        @{ text = ": "; fg = $palette.foreground; bg = $palette.background },
        @{ text = "number"; fg = $palette.type; bg = $palette.background },
        @{ text = ") {"; fg = $palette.foreground; bg = $palette.background }
    ),
    @(
        @{ text = " 5 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "  return"; fg = $palette.keyword; bg = $palette.background },
        @{ text = " "; fg = $palette.foreground; bg = $palette.background },
        @{ text = '<theme ok="true">'; fg = $palette.string; bg = $palette.background },
        @{ text = " + "; fg = $palette.foreground; bg = $palette.background },
        @{ text = "count"; fg = $palette.foreground; bg = $palette.background },
        @{ text = " + "; fg = $palette.foreground; bg = $palette.background },
        @{ text = "42"; fg = $palette.number; bg = $palette.background }
    ),
    @(
        @{ text = " 6 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "}"; fg = $palette.foreground; bg = $palette.background }
    ),
    @(
        @{ text = " 7 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "<Preview"; fg = $palette.tag; bg = $palette.background },
        @{ text = " "; fg = $palette.foreground; bg = $palette.background },
        @{ text = "theme"; fg = $palette.tag; bg = $palette.background },
        @{ text = "="; fg = $palette.foreground; bg = $palette.background },
        @{ text = '"tr4shy_colors"'; fg = $palette.string; bg = $palette.background },
        @{ text = " />"; fg = $palette.tag; bg = $palette.background }
    ),
    @(
        @{ text = " 8 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "added line"; fg = $palette.added; bg = $palette.background }
    ),
    @(
        @{ text = " 9 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "removed line"; fg = $palette.removed; bg = $palette.background }
    ),
    @(
        @{ text = "10 "; fg = $palette.comment; bg = $palette.gutter },
        @{ text = "invalid token"; fg = $palette.invalidFg; bg = $palette.invalidBg }
    )
)

foreach ($line in $lines) {
    $rendered = ""
    foreach ($segment in $line) {
        $rendered += Paint $segment.text $segment.fg $segment.bg
    }
    Write-Host $rendered
}

Write-Host ""
Write-Host "Run again with:"
Write-Host "  pwsh .\themes\codex\preview-tr4shy-codex-theme.ps1"
Write-Host ""
