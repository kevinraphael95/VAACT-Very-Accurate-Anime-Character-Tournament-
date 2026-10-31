--機械天使の絶対儀式
--Machine Angel Absolute Ritual
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 11398951) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(11398951)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	Ritual.AddProcEqual{handler=c,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,extratg=s.extratg}
end
s.listed_series={SET_CYBER_ANGEL}
function s.ritualfil(c)
	return c:IsSetCard(SET_CYBER_ANGEL) and c:IsRitualMonster()
end
function s.mfilter(c)
	return c:HasLevel() and c:IsRace(RACE_WARRIOR|RACE_FAIRY) and c:IsAbleToDeck()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
	else
		return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil):Filter(aux.nvfilter,nil)
	end
end
function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsRace,nil,RACE_WARRIOR|RACE_FAIRY)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoDeck(mat2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end