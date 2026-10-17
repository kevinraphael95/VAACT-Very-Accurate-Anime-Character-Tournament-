--[VAACT] Échange
local s,id=GetID()
local ECHANGE_ID = 910000064

function s.initial_effect(c)
	-- Traité comme Exchange officiel (ID 31036355)
	local e_add = Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(31036355)
	c:RegisterEffect(e_add)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 
			and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_HAND)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(tp, Duel.GetFieldGroup(tp,0,LOCATION_HAND))
	Duel.ConfirmCards(1-tp, Duel.GetFieldGroup(tp,LOCATION_HAND,0))
	
	local g1 = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	local g2 = Duel.GetFieldGroup(tp, 0, LOCATION_HAND)
	
	if #g1 == 0 or #g2 == 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, 1-tp, HINTMSG_ATOHAND)
	local sg2 = g1:Select(1-tp, 1, 1, nil)
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local sg1 = g2:Select(tp, 1, 1, nil)
	
	local tc1 = sg1:GetFirst()
	local tc2 = sg2:GetFirst()
	
	if tc1 and tc2 then
		Duel.SendtoHand(tc1, tp, REASON_EFFECT)
		Duel.SendtoHand(tc2, 1-tp, REASON_EFFECT)
		Duel.ConfirmCards(tp, tc1)
		Duel.ConfirmCards(1-tp, tc2)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
end