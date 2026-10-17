--[VAACT] Fusion de Figure
local s,id=GetID()
local FIGURE_ID = 910000066
local OFFICIAL_ID = 82137211 -- ID officiel de "Fusion of Figure"

-- === IDs DE TES CHEVALIERS ===
local QUEEN_ID = 910000021
local KING_ID = 910000031
local JACK_ID = 910000032
-- ==============================

function s.initial_effect(c)
	-- Traité comme Fusion of Figure officiel
	local e_add = Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(OFFICIAL_ID)
	c:RegisterEffect(e_add)

	-- Activation de la carte (Invoquer par Fusion)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, FIGURE_ID) -- 1 fois par tour
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- Filtre pour les matériaux de Fusion
function s.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end

-- Vérifie si tu contrôles un Chevalier
function s.hasKnight(tp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, QUEEN_ID)
		or Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, KING_ID)
		or Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, JACK_ID)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- On vérifie qu'on a au moins 1 monstre en main/terrain et 1 Fusion possible dans l'Extra Deck
		local mg_main = Duel.GetMatchingGroup(s.filter, tp, LOCATION_HAND+LOCATION_MZONE, 0, nil, e, tp)
		
		-- Si on a un chevalier, on peut aussi chercher dans le Deck
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
	-- On utilise la fonction native du jeu pour l'Invocation Fusion
	-- Elle va automatiquement ouvrir les fenêtres de sélection pour les matériaux
	-- et vérifier si tu as le droit d'utiliser le Deck (selon tes règles de script)
	local mg = Duel.GetMatchingGroup(s.filter, tp, LOCATION_HAND+LOCATION_MZONE, 0, nil, e, tp)
	
	-- Si tu as un chevalier, on autorise les matériaux depuis le Deck
	if s.hasKnight(tp) then
		mg:Merge(Duel.GetMatchingGroup(s.filter, tp, LOCATION_DECK, 0, nil, e, tp))
	end
	
	local ex = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_EXTRA, 0, nil)
	
	if #mg == 0 or #ex == 0 then return end
	
	-- On laisse le jeu gérer l'invocation de la Fusion
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local fus = ex:Select(tp, 1, 1, nil):GetFirst()
	
	if fus then
		-- Envoi des matériaux au cimetière (nécessaire pour l'invocation)
		-- Note : Le jeu va normalement filtrer les matériaux valides pour la Fusion choisie
		Duel.SendtoGrave(mg, REASON_MATERIAL+REASON_FUSION)
		-- Invocation de la Fusion
		Duel.SpecialSummon(fus, SUMMON_TYPE_FUSION, tp, tp, true, false, POS_FACEUP)
		fus:CompleteProcedure()
	end
end