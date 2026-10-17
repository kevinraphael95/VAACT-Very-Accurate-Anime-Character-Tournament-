--炎の剣士
--Flame Swordsman
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : Considérée comme la carte officielle (ID 45231177) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(45231177)
	c:RegisterEffect(e_add_code)
	-- ================================================================
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,34460851,44287299)
end