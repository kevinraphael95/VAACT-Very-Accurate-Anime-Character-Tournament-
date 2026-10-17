--[VAACT] Quinte du Harlequin
local s,id=GetID()

-- === IDs ET NOMS FACILEMENT MODIFIABLES ===
local HARLEQUIN_ID = 910000067 -- L'ID de cette carte
local QUEEN_ID = 910000021     -- ID de Chevalier de la Reine
local JACK_ID = 910000032      -- ID de Chevalier du Valet
local KING_ID = 910000031      -- ID de Chevalier du Roi
-- ==================================

function s.initial_effect(c)
	-- 1) Effet principal : Activation (Défausser, Invoquer, Ajouter, Invoquer Normalement)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, HARLEQUIN_ID) -- 1 par tour pour cet effet
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	-- 2) Effet depuis le Cimetière : Recycler une carte et se récupérer
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O) -- Activation rapide (durant la End Phase)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE) -- Uniquement si la carte est dans le Cimetière
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, HARLEQUIN_ID+1) -- 1 par tour pour cet effet (ID+1 pour le différencier)
	e2:SetCondition(s.gycon)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end

-- === EFFET 1 : ACTIVATION ===
function s.spfilter(c,e,tp)
	return (c:IsCode(QUEEN_ID) or c:IsCode(JACK_ID)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter(c)
	return c:IsCode(KING_ID) or c:IsCode(JACK_ID)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK, 0, 1, nil, e, tp)
			and Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
			and Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES, nil, 1, tp, 0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 1) Défausser 1 carte
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
	local dg = Duel.SelectMatchingCard(tp, Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, 1, nil)
	if #dg > 0 then
		Duel.SendtoGrave(dg, REASON_DISCARD+REASON_EFFECT)
	else
		return
	end

	-- 2) Invoquer Spécialement la Reine ou le Valet depuis le Deck
	local sg = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_DECK, 0, nil, e, tp)
	if #sg > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local ssp = sg:Select(tp, 1, 1, nil)
		Duel.SpecialSummon(ssp, 0, tp, tp, false, false, POS_FACEUP)
	end

	-- 3) Ajouter le Roi ou le Valet depuis le Deck à la main
	local tg = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
	if #tg > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sth = tg:Select(tp, 1, 1, nil)
		Duel.SendtoHand(sth, tp, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, sth)
	end

	-- 4) Invoquer Normalement 1 monstre
	-- On crée un effet pour autoriser une invocation normale supplémentaire
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE, 0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsMonster))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1, tp)
end

-- === EFFET 2 : DEPUIS LE CIMETIÈRE ===
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase() == PHASE_END
end

function s.gyfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end

function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.gyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.gyfilter, tp, LOCATION_GRAVE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectTarget(tp, s.gyfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK, g, 1, 0, 0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
end

function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc, nil, SEQ_DECKSHUFFLE, REASON_EFFECT) > 0 then
		if c:IsRelateToEffect(e) then
			Duel.SendtoHand(c, tp, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, c)
		end
	end
end