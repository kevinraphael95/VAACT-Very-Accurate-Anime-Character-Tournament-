--トリックスター・カスケード
--Trickstar Cascade
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 511009612) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(511009612)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0xfb}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetAttacker():IsControler(tp)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_TRICKSTAR) and c:IsAbleToHandAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_COST)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end