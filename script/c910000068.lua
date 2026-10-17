--[VAACT] Invocation à la Vitesse de l'Éclair
local s,id=GetID()
local VITESSE_ID = 910000068
local QUEEN_ID = 910000021
local KING_ID = 910000032
local JACK_ID = 910000031

function s.initial_effect(c)
	-- Traité comme Thunder Speed Summon officiel (ID 2191146)
	local e_add = Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(2191146)
	c:RegisterEffect(e_add)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, VITESSE_ID)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph = Duel.GetCurrentPhase()
	return ph == PHASE_MAIN1 or ph == PHASE_MAIN2 or ph == PHASE_BATTLE
end

function s.hasAllKnights(tp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, QUEEN_ID)
		and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, KING_ID)
		and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, JACK_ID)
end

function s.thfilter(c)
	return c:IsLevel(10) and not c:IsAttribute(ATTRIBUTE_DARK) and c:GetBaseAttack() == 0 and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if s.hasAllKnights(tp) then
			return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
		end
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
	end
	if s.hasAllKnights(tp) then
		Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	end
	Duel.SetOperationInfo(0, CATEGORY_SUMMON, nil, 1, tp, 0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if s.hasAllKnights(tp) then
		local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
		if #g > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sg = g:Select(tp, 1, 1, nil)
			Duel.SendtoHand(sg, tp, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, sg)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE, 0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsMonster))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1, tp)
end