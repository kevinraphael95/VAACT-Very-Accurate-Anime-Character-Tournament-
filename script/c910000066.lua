--[VAACT] Fusion de Figure
local s,id=GetID()
local FIGURE_ID = 910000066

function s.initial_effect(c)
	-- Traité comme Fusion of Figure officiel (ID 82137211)
	local e_add = Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(82137211)
	c:RegisterEffect(e_add)

	-- Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, FIGURE_ID)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter(c,e,tp,mg)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end

function s.hasKnight(tp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 0x1234)
		or Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 0x1235)
		or Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 0x1236)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg_main = Duel.GetMatchingGroup(s.filter, tp, LOCATION_HAND+LOCATION_MZONE, 0, nil, e, tp)
		if s.hasKnight(tp) then
			local mg_deck = Duel.GetMatchingGroup(s.filter, tp, LOCATION_DECK, 0, nil, e, tp)
			if #mg_deck > 0 then
				return Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_EXTRA, 0, 1, nil) and #mg_main > 0
			end
		end
		return Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_EXTRA, 0, 1, nil) and #mg_main > 0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_FUSION_SUMMON, nil, 0, 0, 0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg = Duel.GetMatchingGroup(s.filter, tp, LOCATION_HAND+LOCATION_MZONE, 0, nil, e, tp)
	local ex = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_EXTRA, 0, nil)
	
	if #mg == 0 or #ex == 0 then return end
	
	local fc = ex:GetFirst()
	
	-- Correction : On utilise une fonction anonyme qui accepte les 3 paramètres (c, e, tp)
	-- pour éviter l'erreur "3 parameters are needed"
	local mat = mg:Filter(function(c, e, tp) return true end, nil, tp)
	
	if fc and mat then
		-- On envoie les matériaux au Cimetière
		Duel.SendtoGrave(mat, REASON_MATERIAL+REASON_FUSION)
		
		-- On invoque la Fusion
		Duel.SpecialSummon(fc, SUMMON_TYPE_FUSION, tp, tp, true, false, POS_FACEUP)
		fc:CompleteProcedure()
	end
end