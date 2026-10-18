--[VAACT] Échange
local s,id=GetID()

function s.initial_effect(c)
	-- Traité comme Exchange officiel (ID 555668)
	local e_add = Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(555668)
	c:RegisterEffect(e_add)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_HAND)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g1==0 or #g2==0 then return end
	
	-- Révéler les deux mains
	Duel.ConfirmCards(tp,g2)
	Duel.ConfirmCards(1-tp,g1)
	
	-- Toi tu choisis une carte dans sa main
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local ag1=g2:Select(tp,1,1,nil)
	
	-- L'adversaire choisit une carte dans ta main
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local ag2=g1:Select(1-tp,1,1,nil)
	
	-- Échanger les cartes
	if ag1 and ag2 then
		Duel.SendtoHand(ag1,tp,REASON_EFFECT)
		Duel.SendtoHand(ag2,1-tp,REASON_EFFECT)
	end
end