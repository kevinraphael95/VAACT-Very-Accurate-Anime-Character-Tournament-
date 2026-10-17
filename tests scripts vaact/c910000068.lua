--[VAACT] Invocation à la Vitesse de l'Éclair
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local VITESSE_ID = 910000068 -- L'ID de cette carte
local QUEEN_ID = 910000021   -- ID de Chevalier de la Reine
local KING_ID = 910000032    -- ID de Chevalier du Roi
local JACK_ID = 910000031    -- ID de Chevalier du Valet
-- ==================================

function s.initial_effect(c)
	-- Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, VITESSE_ID) -- 1 par tour
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- Condition : Seulement durant la Main Phase ou la Battle Phase
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph = Duel.GetCurrentPhase()
	return ph == PHASE_MAIN1 or ph == PHASE_MAIN2 or ph == PHASE_BATTLE
end

-- Vérifie si le joueur contrôle les 3 Chevaliers
function s.hasAllKnights(tp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, QUEEN_ID)
		and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, KING_ID)
		and Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, JACK_ID)
end

-- Filtre pour l'effet alternatif : Niveau 10, non-TÉNÈBRES, ATK "?" (0)
function s.thfilter(c)
	return c:IsLevel(10) and not c:IsAttribute(ATTRIBUTE_DARK) and c:GetBaseAttack() == 0 and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if s.hasAllKnights(tp) then
			-- Si on a les 3 chevaliers, on vérifie qu'il y a une carte valide dans le Deck
			return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
		end
		-- Sinon, on vérifie juste qu'on peut invoquer normalement
		return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
	end
	
	if s.hasAllKnights(tp) then
		Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	end
	Duel.SetOperationInfo(0, CATEGORY_SUMMON, nil, 1, tp, 0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- Si on a les 3 chevaliers, on applique l'effet alternatif
	if s.hasAllKnights(tp) then
		-- 1) Ajouter la carte Niv 10 non-TÉNÈBRES ? ATK du Deck à la main
		local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
		if #g > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sg = g:Select(tp, 1, 1, nil)
			Duel.SendtoHand(sg, tp, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, sg)
		end
	end
	
	-- 2) Invoquer Normalement 1 monstre (dans les deux cas)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE, 0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsMonster))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1, tp)
end