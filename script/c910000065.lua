--[VAACT] L'Œil de Timée
local s,id=GetID()

-- === IDs FACILEMENT MODIFIABLES ===
local TIMEE_ID = 910000065 -- L'ID de cette carte

-- Liste des IDs de "Magicien Sombre" (Vrais + Perso)
local MAGICIANS_SOMBRES = {
	910000000, -- Ton ID perso
	46986414,  -- Magicien Sombre (Normal)
	70781052,  -- Magicien Sombre (Rituel/Alternatif)
	50287024,  -- Magicien Sombre (Chevalier du Dragon)
	36996508,  -- Magicien Sombre (Illusion)
	97631303,  -- Magicien Sombre (Envoyé du Crépuscule)
}

-- Liste des IDs de "Magicienne des Ténèbres" (Vrais + Perso)
local MAGICIENNES_TENEBRES = {
	910000001, -- Ton ID perso
	38033121,  -- Magicienne des Ténèbres (Normale)
	43803845,  -- Magicienne des Ténèbres (Chevalier du Dragon)
}

-- Fonction utilitaire pour vérifier si un ID est dans la liste
local function isInTable(t, val)
	for _, v in ipairs(t) do
		if v == val then return true end
	end
	return false
end
-- ==================================

function s.initial_effect(c)
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

-- Vérifie si le monstre ciblé peut être utilisé pour une Fusion
function s.filter(c, e, tp)
	if not (c:IsFaceup() and c:IsControler(tp)) then return false end
	return Duel.IsExistingMatchingCard(s.checkFusion, tp, LOCATION_EXTRA, 0, 1, nil, c, tp)
end

-- Vérifie si la Fusion correspond
function s.checkFusion(fc, mc, tp)
	if not fc:IsType(TYPE_FUSION) then return false end
	
	local target_code = mc:GetCode()
	local is_magician = isInTable(MAGICIANS_SOMBRES, target_code) or isInTable(MAGICIENNES_TENEBRES, target_code)
	
	-- Si le monstre ciblé n'est pas un Magicien Sombre/Ténèbres, on vérifie si la Fusion le mentionne quand même.
	-- Mais d'après la carte, c'est sensé être listé sur la Fusion.
	
	local mg = fc:GetMaterial()
	if mg then
		for m in aux.Next(mg) do
			if m:IsCode(target_code) then return true end
		end
	end
	
	-- Si la Fusion est une Fusion qui mentionne spécifiquement ces monstres
	-- (via SETCODE ou texte)
	if is_magician then
		-- Si le monstre ciblé est un Magicien Sombre, on autorise les Fusions qui mentionnent ces noms
		return fc:IsSetCard(0x123) or fc:IsCode(910000000) or fc:IsCode(910000001) 
			or fc:IsCode(46986414) or fc:IsCode(38033121)
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
	local extra = Duel.GetMatchingGroup(s.checkFusion, tp, LOCATION_EXTRA, 0, nil, tc, tp)
	
	if #extra == 0 then return end
	
	-- Demander au joueur de choisir quelle Fusion invoquer
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sg = extra:Select(tp, 1, 1, nil)
	local fus = sg:GetFirst()
	
	if fus then
		Duel.SpecialSummon(fus, SUMMON_TYPE_FUSION, tp, tp, true, false, POS_FACEUP)
	end
end