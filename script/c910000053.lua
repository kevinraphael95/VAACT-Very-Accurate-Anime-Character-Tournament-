--[VAACT] Rideau de Magie Noire
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local RIDEAU_ID = 910000053 -- L'ID de cette carte
-- ==================================

function s.initial_effect(c)
	-- Activation de la carte
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, RIDEAU_ID) -- 1 fois par tour
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- Coût : Payer la moitié de ses LP
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp, math.floor(Duel.GetLP(tp)/2)) end
	Duel.PayLPCost(tp, math.floor(Duel.GetLP(tp)/2))
end

-- Filtre : Monstre Magicien pour le joueur qui active
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND) -- Pour l'adversaire
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 1) Toi : Invoquer un Magicien depuis ton Deck
	if Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local g = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
		if #g > 0 then
			Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
	
	-- 2) L'adversaire peut payer la moitié de ses LP pour invoquer un Magicien de sa main
	local lp_cost = math.floor(Duel.GetLP(1-tp) / 2)
	
	-- On vérifie qu'il a assez de LP, de place et une carte valide en main
	if Duel.CheckLPCost(1-tp, lp_cost) 
		and Duel.GetLocationCount(1-tp, LOCATION_MZONE) > 0 
		and Duel.IsExistingMatchingCard(s.spfilter, 1-tp, LOCATION_HAND, 0, 1, nil, e, 1-tp) then
		
		-- On demande à l'adversaire s'il veut payer (l'IA le fera, ou un prompt apparaîtra)
		if Duel.SelectYesNo(1-tp, aux.Stringid(RIDEAU_ID, 0)) then
			Duel.PayLPCost(1-tp, lp_cost)
			
			Duel.Hint(HINT_SELECTMSG, 1-tp, HINTMSG_SPSUMMON)
			local sg = Duel.SelectMatchingCard(1-tp, s.spfilter, 1-tp, LOCATION_HAND, 0, 1, 1, nil, e, 1-tp)
			if #sg > 0 then
				Duel.SpecialSummon(sg, 0, 1-tp, 1-tp, false, false, POS_FACEUP)
			end
		end
	end
end