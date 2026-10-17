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

	-- Activation de la carte
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, FIGURE_ID) -- 1 fois par tour
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- Vérifie si tu contrôles un Chevalier
function s.hasKnight(tp)
	return Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, QUEEN_ID)
		or Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, KING_ID)
		or Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_MZONE, 0, 1, nil, JACK_ID)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- On vérifie qu'il y a de quoi faire une fusion
		local mg_main = Duel.GetMatchingGroup(nil, tp, LOCATION_HAND+LOCATION_MZONE, 0, nil)
		local can_fuse = Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_EXTRA, 0, 1, nil)
		
		if not can_fuse then return false end
		
		-- Si on a un chevalier, on peut piocher dans le Deck
		if s.hasKnight(tp) then
			return true -- Le jeu fera les vérifications précises lors de la sélection
		end
		
		return #mg_main > 0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_FUSION_SUMMON, nil, 0, 0, 0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- On laisse EDOPro gérer entièrement la sélection de la Fusion et des matériaux
	local fc = Duel.GetFusionMaterial(tp)
	
	-- On ajoute le Deck aux matériaux disponibles si tu contrôles un Chevalier
	if s.hasKnight(tp) then
		fc:Merge(Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial, tp, LOCATION_DECK, 0, nil))
	end
	
	-- On lance l'invocation par Fusion standard du jeu
	-- Le "true" à la fin autorise l'utilisation des matériaux du Deck
	Fusion.SummonEffOP(e,tp,eg,ep,ev,re,r,rp,fc,true)
end