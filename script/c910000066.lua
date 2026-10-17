--[VAACT] Fusion de Figure
local s,id=GetID()

-- === IDs ET NOMS FACILEMENT MODIFIABLES ===
local FIGURE_ID = 910000066 -- L'ID de cette carte
-- ==================================

function s.initial_effect(c)
	-- Activation de la carte
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, FIGURE_ID) -- 1 par tour
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter(c,e,tp,mg)
	-- Vérifie si le monstre peut être utilisé comme matériel de fusion
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end

-- Vérifie si le joueur contrôle un Chevalier
function s.hasKnight(tp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 0x1234) -- Remplacer 0x1234 par l'ID réel des chevaliers
		or Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 0x1235)
		or Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, 0x1236)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- On cherche une fusion possible avec la main/terrain, et éventuellement le deck
		local mg_main = Duel.GetMatchingGroup(s.filter, tp, LOCATION_HAND+LOCATION_MZONE, 0, nil, e, tp)
		
		-- Si on a un chevalier, on peut ajouter le deck à la liste
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
	
	-- 1) On demande au joueur de choisir les matériels de Fusion
	local mg = Duel.GetMatchingGroup(s.filter, tp, LOCATION_HAND+LOCATION_MZONE, 0, nil, e, tp)
	local ex = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_EXTRA, 0, nil)
	
	if #mg == 0 or #ex == 0 then return end
	
	-- Ici on devrait utiliser une interface de sélection pour la fusion
	-- Pour simplifier, on va chercher une fusion possible automatiquement
	local fc = ex:GetFirst() -- Prend la première fusion possible (à adapter)
	local mat = mg:Filter(function(c) return true end) -- On prend tous les matériels (à adapter)
	
	if fc and mat then
		-- Invoquer la fusion
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE) -- Si nécessaire
		Duel.SpecialSummon(fc, SUMMON_TYPE_FUSION, tp, tp, true, false, POS_FACEUP)
	end
end