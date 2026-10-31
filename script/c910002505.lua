--大邪神の儀式
--Final Ritual of the Ancients
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 60369732) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(60369732)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	Ritual.AddProcGreaterCode(c,8,nil,62420419)
end