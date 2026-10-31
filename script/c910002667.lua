--古代の機械融合
--Ancient Gear Fusion
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 64061284) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(64061284)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,SET_ANCIENT_GEAR),nil,s.fextra,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,s.extratg)
	c:RegisterEffect(e1)
end
s.listed_series={SET_ANCIENT_GEAR}
s.listed_names={CARD_ANCIENT_GEAR_GOLEM,95735217}
function s.filterchk(c)
	return c:IsFaceup() and c:IsCode(CARD_ANCIENT_GEAR_GOLEM,95735217) and c:IsOnField()
end
function s.fcheck(tp,sg,fc)
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		return sg:IsExists(s.filterchk,1,nil) end
	return true
end
function s.fextra(e,tp,mg)
	if mg:IsExists(s.filterchk,1,nil) then
		local eg=Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToGrave),tp,LOCATION_DECK,0,nil)
		if eg and #eg>0 then
			return eg,s.fcheck
		end
	end
	return nil
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end