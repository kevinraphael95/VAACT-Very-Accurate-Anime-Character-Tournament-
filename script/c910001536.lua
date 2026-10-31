--サイバーダーク・インパクト！
--Cyberdark Impact!
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 80033124) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(80033124)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsCode,40418351),Card.IsAbleToDeck,s.fextra,Fusion.ShuffleMaterial,nil,nil,nil,nil,nil,nil,nil,nil,nil,s.extratg)
	c:RegisterEffect(e1)
end
s.listed_names={40418351,41230939,77625948,3019642}
function s.matfilter(c,lc,stype,tp)
	return c:IsSummonCode(lc,stype,tp,41230939,77625948,3019642) and c:IsAbleToDeck()
end
function s.frec(c,tp,sg,g,code,...)
	if not c:IsSummonCode(fc,SUMMON_TYPE_FUSION,tp,code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(s.frec,1,g,tp,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function s.fcheck(tp,sg,fc,mg)
	return #sg==3 and sg:IsExists(s.frec,1,nil,tp,sg,Group.CreateGroup(),41230939,77625948,3019642)
end
function s.fextra(e,tp,mg)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_ONFIELD|LOCATION_GRAVE,0,nil)
	return g,s.fcheck
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND|LOCATION_ONFIELD|LOCATION_GRAVE)
end