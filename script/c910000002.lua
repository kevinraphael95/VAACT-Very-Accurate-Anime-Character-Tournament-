--[VAACT] Magicienne des Ténèbres (Dark Magician Girl)
local s,id=GetID()

--IDs de "Magicien Sombre" (Dark Magician) : version VAACT et version officielle
--à modifier ici si besoin
s.magicien_sombre={910000000,46986414}

s.listed_names={910000000,46986414}

function s.initial_effect(c)
	--Gagne 500 ATK pour chaque "Magicien Sombre" dans les Cimetières
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
end
function s.filter(c)
	for _,code in ipairs(s.magicien_sombre) do
		if c:IsCode(code) then return true end
	end
	return false
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*500
end