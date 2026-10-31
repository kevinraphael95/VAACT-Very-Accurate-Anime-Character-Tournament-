--Final Penalty
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 511000059) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(511000059)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP)
		and c==Duel.GetAttackTarget() and c:IsRace(RACE_FIEND) and c:IsLocation(LOCATION_GRAVE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at end
	if chk==0 then return at:IsControler(1-tp) and at:IsRelateToBattle() and at:IsCanBeEffectTarget(e) and at:IsDestructable() end
	Duel.SetTargetCard(at)
	local atk=at:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,at,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetFirstTarget()
	if a:IsRelateToEffect(e) then
		local atk=a:GetAttack()
		if Duel.Damage(1-tp,atk,REASON_EFFECT) then
			Duel.Destroy(a,REASON_EFFECT)
		end
	end
end