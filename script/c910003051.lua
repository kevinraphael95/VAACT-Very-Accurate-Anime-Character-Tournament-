--Supreme King Violent Spirit
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 511009518) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(511009518)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	aux.AddEquipProcedure(c,nil,s.filter)
	--Pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(id)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSetCard(0xf8) and c:IsFaceup() 
end