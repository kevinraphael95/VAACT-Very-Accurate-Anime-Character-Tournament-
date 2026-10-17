--[VAACT] L'Œil de Timée
local s,id=GetID()
local TIMEE_ID = 910000065

-- Liste des IDs de "Magicien Sombre"
local MAGICIANS_SOMBRES = { 910000000, 46986414, 70781052, 50287024, 36996508, 97631303 }
-- Liste des IDs de "Magicienne des Ténèbres"
local MAGICIENNES_TENEBRES = { 910000001, 38033121, 43803845 }

local function isInTable(t, val)
	for _, v in ipairs(t) do if v == val then return true end end
	return false
end

function s.initial_effect(c)
	-- Traité comme The Eye of Timaeus officiel (ID 80000038)
	local e_add = Effect.CreateEffect(c)
	e_add:SetType(EFFECT_TYPE_SINGLE)
	e_add:SetCode(EFFECT_ADD_CODE)
	e_add:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add:SetValue(80000038)
	c:RegisterEffect(e_add)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, TIMEE_ID)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter(c, e, tp)
	if not (c:IsFaceup() and c:IsControler(tp)) then return false end
	return Duel.IsExistingMatchingCard(s.checkFusion, tp, LOCATION_EXTRA, 0, 1, nil, c, tp)
end

function s.checkFusion(fc, mc, tp)
	if not fc:IsType(TYPE_FUSION) then return false end
	local target_code = mc:GetCode()
	local is_magician = isInTable(MAGICIANS_SOMBRES, target_code) or isInTable(MAGICIENNES_TENEBRES, target_code)
	
	local mg = fc:GetMaterial()
	if mg then
		for m in aux.Next(mg) do
			if m:IsCode(target_code) then return true end
		end
	end
	
	if is_magician then
		return fc:IsSetCard(0x123) or fc:IsCode(910000000) or fc:IsCode(910000001) or fc:IsCode(46986414) or fc:IsCode(38033121)
	end
	return false
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc, e, tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter, tp, LOCATION_MZONE, 0, 1, nil, e, tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_FUSION_SUMMON, g, 1, 0, 0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp)) then return end
	local extra = Duel.GetMatchingGroup(s.checkFusion, tp, LOCATION_EXTRA, 0, nil, tc, tp)
	if #extra == 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sg = extra:Select(tp, 1, 1, nil)
	local fus = sg:GetFirst()
	if fus then Duel.SpecialSummon(fus, SUMMON_TYPE_FUSION, tp, tp, true, false, POS_FACEUP) end
end