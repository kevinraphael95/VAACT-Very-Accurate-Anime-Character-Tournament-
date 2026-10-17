--[VAACT] Lien Spirituel
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local LIEN_ID = 910000069 -- L'ID de cette carte
-- ==================================

function s.initial_effect(c)
	-- Activation de la carte
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- Condition : Un monstre que vous contrôlez a été détruit
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g = eg:Filter(Card.IsPreviousControler,nil,tp)
	return g:IsExists(Card.IsPreviousLocation,nil,LOCATION_MZONE) and g:IsExists(Card.IsType,nil,TYPE_MONSTER)
end

-- Coût : Payer 1000 LP
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

-- Filtre pour l'invocation : Monstre de Niveau 4
function s.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- Vérifier la place
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	-- Chercher un monstre Niveau 4 dans le Deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end