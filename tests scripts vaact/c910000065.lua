--[VAACT] L'Œil de Timée
local s,id=GetID()

-- === IDs ET NOMS FACILEMENT MODIFIABLES ===
local TIMEE_ID = 910000065 -- L'ID de cette carte
local TIMEE_NAME = "Dragon Légendaire Timée" -- Le nom alternatif
-- ==================================

function s.initial_effect(c)
	-- Traitement du nom alternatif (comme "Dragon Légendaire Timée")
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_SETCODE)
	e0:SetValue(0x123) -- Si Timée a un archétype (SETCODE), sinon retire cette ligne
	c:RegisterEffect(e0)
	
	-- Nom alternatif
	local e0_1=e0:Clone()
	e0_1:SetCode(EFFECT_ADD_CODE)
	e0_1:SetValue(0x0) -- Si "Dragon Légendaire Timée" a un ID spécifique, mets-le ici
	c:RegisterEffect(e0_1)
	
	-- Effet d'activation : Invoquer par Fusion
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, TIMEE_ID) -- 1 par tour
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- Vérifie si le monstre peut être utilisé comme matériel de Fusion
function s.filter(c, e, tp)
	if not (c:IsFaceup() and c:IsControler(tp)) then return false end
	-- On vérifie s'il existe une Fusion dans l'Extra Deck qui peut utiliser ce monstre
	local extra = Duel.GetExtraDeck(tp)
	return extra:IsExists(s.checkFusion, 1, nil, c, tp)
end

-- Vérifie si la Fusion peut être invoquée avec cette carte sur le terrain
function s.checkFusion(fc, mc, tp)
	if not fc:IsType(TYPE_FUSION) then return false end
	local mg = fc:GetMaterial()
	-- Il faut que la carte mentionne Magicien Sombre / Magicienne des Ténèbres
	-- et que le monstre sur le terrain soit un matériel valide.
	if fc:IsSetCard(0x123) then -- Remplacer par l'ID de l'archétype si besoin
		for m in aux.Next(mg) do
			if m:IsCode(mc:GetCode()) then -- Nom ou Type spécifique
				return true
			end
		end
	end
	return false
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc, e, tp) end
	if chk==0 then
		return Duel.IsExistingTarget(s.filter, tp, LOCATION_MZONE, 0, 1, nil, e, tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_FUSION_SUMMON, g, 1, 0, 0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp)) then return end
	
	-- Trouver les Fusions possibles dans l'Extra Deck
	local extra = Duel.GetExtraDeck(tp)
	local fus_list = {}
	
	for fc in aux.Next(extra) do
		if s.checkFusion(fc, tc, tp) then
			-- Vérifier que toutes les autres conditions de la Fusion sont remplies
			-- (Parfois il faut d'autres matériels dans la main / terrain)
			if fc:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false) then
				table.insert(fus_list, fc)
			end
		end
	end
	
	if #fus_list == 0 then return end -- Aucune Fusion possible
	
	-- Demander au joueur de choisir quelle Fusion invoquer
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sg = Group.FromTable(fus_list):Select(tp, 1, 1, nil)
	local fus = sg:GetFirst()
	
	if fus then
		-- Invoquer la Fusion en utilisant le monstre sur le terrain
		Duel.SpecialSummon(fus, SUMMON_TYPE_FUSION, tp, tp, true, false, POS_FACEUP)
	end
end