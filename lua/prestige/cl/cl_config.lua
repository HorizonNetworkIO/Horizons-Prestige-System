surface.CreateFont("HZNPrestige:N:15", {font = "Open Sans", size = 15})
surface.CreateFont("HZNPrestige:N:20", {font = "Open Sans", size = 20})
surface.CreateFont("HZNPrestige:N:25", {font = "Open Sans", size = 25})
surface.CreateFont("HZNPrestige:B:15", {font = "Open Sans Bold", size = 15})
surface.CreateFont("HZNPrestige:B:20", {font = "Open Sans Bold", size = 20})
surface.CreateFont("HZNPrestige:B:25", {font = "Open Sans Bold", size = 25})
surface.CreateFont("HZNPrestige:B:30", {font = "Open Sans Bold", size = 30})
surface.CreateFont("HZNPrestige:B:45", {font = "Open Sans Bold", size = 45})

HZNPrestige.Items = HZNPrestige.Items or {}

HZNPrestige.Colors = {
    ["DashboardHeader"] = Color(50, 150, 200),
    ["CloseButton"] = Color(10, 36, 49),
    ["SelectedButton"] = Color(255, 255, 255),
    ["TextColor"] = Color(255, 255, 255),
    ["Button"] = Color(37, 113, 151, 148),
    ["HoverButton"] = Color(15, 48, 65, 148),
    ["ButtonDown"] = Color(7, 30, 42, 174),
    ["BackBox"] = Color(37, 113, 151, 148),
    ["LowerPanel"] = Color(13, 54, 75),
    ["PriceText"] = Color(63, 177, 235),
}

function HZNPrestige:DrawText(text, font, x, y, color, xalign, yalign, distance, alpha)
    draw.TextShadow({
        text = text,
        font = font,
        pos = {x, y},
        color = color,
        xalign = xalign,
        yalign = yalign,
    }, (distance or 1), (alpha or 255))

    draw.SimpleText(text, font, x, y, color, xalign, yalign)
end