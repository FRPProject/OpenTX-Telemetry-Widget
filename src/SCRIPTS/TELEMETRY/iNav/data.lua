local r, m, i, HORUS = ...

local function getTelemetryId(n)
	local field = getFieldInfo(n)
	return field and field.id or -1
end

local function getTelemetryUnit(n)
   local field = getFieldInfo(n)
   return (field and field.unit <= 10) and field.unit or 0
end


local tx = "xl" -- string.sub(r, 0, 2)
/* 
if HORUS or string.sub(r, 0, 3) == "x9e" or string.sub(r, 0, 4) == "x9li" or string.sub(r, 0, 6) == "x9d+20" then
	tx = "x7"
end
*/

local MENU
MENU = EVT_VIRTUAL_MENU_LONG
/*
if tx == "xl" then
   MENU = EVT_SHIFT_BREAK
elseif HORUS then
   MENU = EVT_SYS_FIRST
elseif string.sub(r, 0, 3) == "t12" then
   MENU = EVT_VIRTUAL_MENU_LONG
elseif string.sub(r,0,5) == "tlite" then
   MENU = EVT_VIRTUAL_MENU_LONG
elseif string.sub(r,0,5) == "zorro" then
   MENU = EVT_VIRTUAL_MENU_LONG
elseif string.sub(r,0,6) == "lr3pro" then
   MENU = EVT_VIRTUAL_MENU_LONG
else
   MENU = EVT_MENU_BREAK
end
*/

local general = getGeneralSettings()
local distSensor = getTelemetryId("Dist") > -1 and "Dist" or (getTelemetryId("0420") > -1 and "0420" or "0007")
local data = {
	txBattMin = general.battMin,
	txBattMax = general.battMax,
	lang = string.lower(general.language),
	voice = general.voice,
	mode_id = getTelemetryId("Tmp1"),
	rxBatt_id = getTelemetryId("RxBt") > -1 and getTelemetryId("RxBt") or getTelemetryId("BtRx"),
	sat_id = getTelemetryId("Tmp2"),
	gpsAlt_id = getTelemetryId("GAlt"),
	gpsLatLon_id = getTelemetryId("GPS"),
	hdg_id = getTelemetryId("Hdg"),
	fpv_id = getTelemetryId("FPV") > -1 and getTelemetryId("FPV") or getTelemetryId("0450"),
	alt_id = getTelemetryId("Alt"),
	dist_id = getTelemetryId(distSensor),
	curr_id = getTelemetryId("Curr"),
	altMax_id = getTelemetryId("Alt+"),
	distMax_id = getTelemetryId(distSensor .. "+"),
	currMax_id = getTelemetryId("Curr+"),
	batt_id = getTelemetryId("VFAS"),
	battMin_id = getTelemetryId("VFAS-"),
	a4_id = getTelemetryId("A4"),
	a4Min_id = getTelemetryId("A4-"),
	fuel_id = getTelemetryId("Fuel"),
	vspeed_id = getTelemetryId("VSpd"),
	txBatt_id = getTelemetryId("tx-voltage"),
	gpsAlt_unit = getTelemetryUnit("GAlt"),
	alt_unit = getTelemetryUnit("Alt"),
	vspeed_unit = getTelemetryUnit("VSpd"),
	dist_unit = getTelemetryUnit(distSensor),
	thr_id = getTelemetryId("thr"),
	mode = 0,
	modeId = 1,
	satellites = 0,
	gpsAlt = 0,
	heading = 0,
	fpv = 0,
	altitude = 0,
	distance = 0,
	speed = 0,
	current = 0,
	fuel = 0,
	batt = 0,
	cell = 0,
	rxBatt = 0,
	txBatt = 0,
	rssiLast = 0,
	vspeed = 0,
	hdop = 0,
	throttle = 0,
	homeResetPrev = false,
	gpsFixPrev = false,
	altNextPlay = 0,
	altLastAlt = 0,
	battNextPlay = 0,
	battPercentPlayed = 100,
	headFree = false,
	headingHold = false,
	altHold = false,
	config = 0,
	configLast = 1,
	configTop = 1,
	configSelect = 0,
	crsf = false,
	alt = {},
	v = -1,
	simu = string.sub(r, -4) == "simu",
	nv = string.sub(r, 0, 4) == "nv14" or string.sub(r, 0, 4) == "NV14",
	--msg = m + i * 0.1 < 2.2 and "OpenTX v2.2+ Required" or false,
	lastLock = { lat = 0, lon = 0 },
	fUnit = {"mAh", "mWh"},
}

function data.RGB(r, g, b)
  local rgb = lcd.RGB(r, g, b)
  if not rgb then
    rgb = bit32.lshift(bit32.rshift(bit32.band(r, 0xFF), 3), 11)
    rgb = rgb + bit32.lshift(bit32.rshift(bit32.band(g, 0xFF), 2), 5)
    rgb = rgb + bit32.rshift(bit32.band(b, 0xFF), 3)
  end
  return rgb
end

return data, getTelemetryId, getTelemetryUnit, MENU, lcd.drawText, lcd.drawLine, lcd.drawRectangle, lcd.drawFilledRectangle, string.format
