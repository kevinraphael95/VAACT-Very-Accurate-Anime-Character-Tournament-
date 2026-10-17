--[VAACT] Cercueil Maléfique
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local CERCEUIL_ID = 910000059 -- L'ID de cette carte
local OFFICIAL_ID = 65878864 -- L'ID officiel de Dark Coffin
-- ==================================

function s.initial_effect(c)
	-- Traitée comme Cercueil Maléfique officiel
	local e_add = Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(OFFICIAL_ID)
	c:RegisterEffect(e_add)

	-- Activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS+EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	-- On vérifie que l'adversaire a bien invoqué un monstre
	local g = eg:Filter(Card.IsControler,nil,1-tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then
		return #g>0 
			and Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingTarget(Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,nil)
	end
	
	-- On cible un monstre adverse (celui qu'il vient d'invoquer, ou un autre)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.SelectTarget(tp,Card.IsFaceup,1-tp,LOCATION_MZONE,0,1,1,nil)
	
	-- On cible un de tes monstres
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local mg=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg+mg,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg = Duel.GetTargetCards(e)
	if #tg < 2 then return end
	
	-- On récupère nos deux monstres ciblés
	local enemy_mon = tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
	local my_mon = tg:Filter(Card.IsControler,nil,tp):GetFirst()
	
	if not (enemy_mon and my_mon) then return end
	
	local is_spellcaster = my_mon:IsRace(RACE_SPELLCASTER)
	
	-- 1) Envoyer les deux au Cimetière
	Duel.SendtoGrave(Group.FromCards(enemy_mon, my_mon), REASON_EFFECT)
	
	-- 2) Invoquer Spécialement un Magicien
	local loc = LOCATION_GRAVE
	if is_spellcaster then
		loc = LOCATION_GRAVE+LOCATION_DECK -- Si c'était un Magicien, on peut prendre dans le Deck
	end
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,loc,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end