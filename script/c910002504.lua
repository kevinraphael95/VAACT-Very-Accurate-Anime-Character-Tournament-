--イリュージョンの儀式
--Black Illusion Ritual
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 41426869) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(41426869)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	Ritual.AddProcGreaterCode(c,1,nil,64631466)
end