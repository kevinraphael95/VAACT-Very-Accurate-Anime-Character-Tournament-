--誘惑のシャドウ
--Shadow of Eyes
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 58621589) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(58621589)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_MSET)
	e2:SetTarget(s.target2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.target2)
	c:RegisterEffect(e3)
end
function s.filter1(c,tp)
	return c:IsFacedown() and c:IsPreviousPosition(POS_FACEUP) and c:IsControler(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter1,1,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,#eg,0,0)
end
function s.filter2(c,tp)
	return c:IsFacedown() and c:IsControler(1-tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter2,1,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,#eg,0,0)
end
function s.filter3(c,e)
	return c:IsFacedown() and c:IsRelateToEffect(e)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter3,nil,e,tp)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
end