--スチームジャイロイド
--Steam Gyroid
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 5368615) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(5368615)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,18325492,44729197)
end
s.material_setcode=SET_ROID