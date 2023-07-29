require("logic")

local INIT_REGIONS = {
    ["First Hallway"] = false,
    ["First Hallway Room"] = false,
    ["Tutorial"] = false,
    ["Main Island"] = false,
    ["Glass Factory"] = false
}

local regions = INIT_REGIONS

local startLocation = "First Hallway"

function reset()
    regions = INIT_REGIONS
    regions[startLocation] = true
end

function region(regionName)
    return regions(regionName)
end

function sweep()
    local madeChanges = false

    if not regions["First Hallway"] and (
        regions["First Hallway Room"] ) then
        regions["First Hallway"] = true 
        madeChanges = true
    end

    if not regions["First Hallway Room"] and (
        regions["First Hallway"] or
        regions["Tutorial"] ) then
            regions["First Hallway Room"] = true 
            madeChanges = true
    end
    
    if not regions["Tutorial"] and (
        regions["First Hallway Room"] or
        (regions["Main Island"] and MainToTutorial()) ) then
            regions["Tutorial"] = true 
            madeChanges = true
    end

    if not regions["Glass Factory"] and (
        (regions["Main Island"] and MainToGlass()) or
        (regions["Ocean"] and OceanToGlass()) ) then
            regions["Glass Factory"] = true
            madeChanges = true
        end


    
    
    if madeChanges then
        sweep()
    end

    local function MainToTutorial()
        return Tracker:ProviderCountForCode("Expert") == 1 or 
        canSolve("158002-158007")
    end

    local function MainToGlass()
        return (isDoors("off") and hasPanel("Glass Factory Entry Door (Panel)") == 1 and canSolve("158027")) or
        Tracker:ProviderCountForCode("Glass Factory Entry Door") == 1 
    end

    local function OceanToGlass()
        return Tracker:ProviderCountForCode("Glass Factory Back Wall")
    end


end
