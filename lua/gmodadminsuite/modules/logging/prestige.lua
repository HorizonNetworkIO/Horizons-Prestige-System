-- lazy blogs support!
local MODULE = GAS.Logging:MODULE()

MODULE.Category = "HZN"
MODULE.Name = "Prestige"
MODULE.Colour = Color( 255, 173, 50)

MODULE:Setup( function()
	MODULE:Hook( "HZNPrestige:TradedIn", "PrestigeBLOGS", function(ply, points, money)
        local message = "{1} traded in {2} prestige points for {3}."

		MODULE:Log( message, GAS.Logging:FormatPlayer( ply ), GAS.Logging:Highlight(tostring(points)), GAS.Logging:FormatMoney(money) )
	end )
end )

GAS.Logging:AddModule( MODULE )