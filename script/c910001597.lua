--サイバー・チュチュ
--Cyber Tutu
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 49375719) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(49375719)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(s.dacon)
	c:RegisterEffect(e1)
end
function s.filter(c,atk)
	return c:IsFacedown() or c:GetAttack()<=atk
end
function s.dacon(e)
	return not Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
end