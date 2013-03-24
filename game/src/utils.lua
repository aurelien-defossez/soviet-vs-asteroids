local red2green = {
	{ 255, 46, 18 },
	{ 248, 127, 34 },
	{ 38, 228, 0 }
}

local blue2red = {
	{ 255, 46, 18 },
	{ 230, 29, 185 },
	{ 7, 163, 228 }
}

function interpolateColorScheme(ratio)
	ratio = math.max(0, math.min(ratio, 1))

	local colorScheme = blue2red
	local nbSteps = #colorScheme - 1
	local ratioPart = 1.0 / nbSteps
	local ratioStep = math.min(math.floor(ratio / ratioPart), nbSteps - 1)
	local localRatio = (ratio - ratioStep * ratioPart) * nbSteps

	return interpolateColor(colorScheme[ratioStep + 1], colorScheme[ratioStep + 2], localRatio)
end

function interpolateColor(startColor, endColor, ratio)
	return {
		startColor[1] + ratio * (endColor[1] - startColor[1]),
		startColor[2] + ratio * (endColor[2] - startColor[2]),
		startColor[3] + ratio * (endColor[3] - startColor[3])
	}
end
