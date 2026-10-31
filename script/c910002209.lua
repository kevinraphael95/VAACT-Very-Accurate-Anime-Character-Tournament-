--撲滅の使徒
--Nobleman of Extermination
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 17449108) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(17449108)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Destroy 1 face-down Spell/Trap card, banish it if it is a Trap and all cards with the same name
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and s.filter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)>0 and tc:IsTrap() then
		local code=tc:GetCode()
		local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,g)
		g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
		local rmvg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,LOCATION_DECK,nil,code)
		if #rmvg>0 then
			Duel.Remove(rmvg,POS_FACEUP,REASON_EFFECT)
		end
	end
end