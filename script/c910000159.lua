--時の魔術師
--Time Wizard
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : Considérée comme la carte officielle (ID 71625222) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(71625222)
	c:RegisterEffect(e_add_code)
	-- ================================================================
	--Destroy monsters on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.toss_coin=true
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,1,tp,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CallCoin(tp) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,e,0,0,tp,0)
	else
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		Duel.Destroy(g,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup():Filter(Card.IsPreviousPosition,nil,POS_FACEUP)
		local sum=dg:GetSum(Card.GetPreviousAttackOnField)
		if sum>0 then
			Duel.Damage(tp,sum/2,REASON_EFFECT)
		end
	end
end
