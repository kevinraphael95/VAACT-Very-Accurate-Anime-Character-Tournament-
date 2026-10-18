--[VAACT] Soul Taker
local s,id=GetID()

--ID de la carte officielle (traitée comme elle) : à modifier ici si besoin
s.officiel=81510157

function s.initial_effect(c)
	--Traitée comme Soul Taker officielle
	local e_add=Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(s.officiel)
	c:RegisterEffect(e_add)

	--L'adversaire gagne 1000 LP, puis cibler 1 monstre face recto adverse : le détruire, ou le Sacrifier comme si vous le contrôliez
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(1-tp,1000,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsFaceup() and tc:IsRelateToEffect(e)) then return end
	local op=Duel.SelectEffect(tp,
		{true,aux.Stringid(id,0)},
		{true,aux.Stringid(id,1)})
	if op==1 then
		--Le détruire
		Duel.Destroy(tc,REASON_EFFECT)
	else
		--Ce tour-ci, vous pouvez le Sacrifier comme si vous le contrôliez
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_RELEASE_SUM)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_EXTRA_RELEASE_NONSUM)
		tc:RegisterEffect(e2)
	end
end
