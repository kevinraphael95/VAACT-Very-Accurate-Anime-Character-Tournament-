--トライアングル・フォース
--Triangle Force
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 100000236) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(100000236)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,tp)
	return c:GetCode()==id and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,tp)
	Duel.BreakEffect()
	if #dg>1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
	 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,2,2,nil,tp)
		if #g>1 then
			local tc=g:GetFirst()
			local tc2=g:GetNext()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end