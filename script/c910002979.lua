--破滅の紋章
Duel.LoadScript("c420.lua")
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 100000219) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(100000219)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(function(c) return c:IsHeraldic() end))
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local dam=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*300
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,dam)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dam=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*300
	Duel.Damage(tp,dam,REASON_EFFECT,true)
	Duel.Damage(1-tp,dam,REASON_EFFECT,true)
	Duel.RDComplete()
end