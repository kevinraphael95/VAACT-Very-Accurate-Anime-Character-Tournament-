--超機合体
--Ultimate Machine Union
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 100000390) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(100000390)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--activate
	local e1=Fusion.CreateSummonEff({handler=c,fusfilter=aux.FilterBoolFunction(Card.IsSetCard,SET_ROID),matfilter=aux.FALSE,extrafil=s.fextra,extraop=Fusion.BanishMaterial,extratg=s.extratg})
	c:RegisterEffect(e1)
end
s.listed_series={0x16}
function s.filter(c,p)
	return c:IsAbleToRemove() and c:IsSetCard(SET_ROID,nil,SUMMON_TYPE_FUSION,p)
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(s.filter),tp,LOCATION_GRAVE,0,nil,tp)
	else
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(s.filter),tp,LOCATION_ONFIELD,0,nil,tp)
	end
	return nil
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end