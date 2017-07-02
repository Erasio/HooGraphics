utils = {}

-- Extend type functionality to consider custom classes (which have to contain their classname as variable "ObjectType")
utils.type = function( obj )
    local otype = type( obj )
    if otype == "table" and obj.ObjectType then
        return obj.ObjectType
    end
    return otype
end

-- Checks through the inheritance structure of hump classes if obj is of type "name"
utils.typeOf = function( obj, name )
    if obj then
        if obj.ObjectType == name then
            return obj
        end
        if obj.__includes then
            if obj.__includes.ObjectType then
                return utils.typeOf(obj.__includes, name)
            end

            for k, v in pairs(obj.__includes) do
                if type(v) == "table" then
                    if v.ObjectType then
                        local tempTypeOf = typeOf(v, name)
                        if tempTypeOf then
                            return tempTypeOf
                        end
                    end
                end
            end
        end
    end
end

--Returns either the hump class that is the parent of this class or in case of multiple inheritance return a table containing all parents
utils.parents = function( obj )
    local parents = {}
    local count  = 0 
    if obj then
        if obj.__includes then
            for k, v in pairs(obj.__includes) do
                if original_type(v) == "table" then
                    if v.ObjectType then
                        parents[v.ObjectType] = v
                        count = count + 1
                    end
                end
            end
        end
    end
    return parents
end

utils.parent = function( obj )
    if obj then
        if obj.__includes then
            for k, v in pairs(obj.__includes) do
                if type(v) == "table" then
                    if v.ObjectType then
                        return v
                    end
                end
            end
        end
    end
end

return utils

