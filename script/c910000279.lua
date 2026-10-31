--ミラクル・コンタクト
--Miracle Contact
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 35255456) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(35255456)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	c:RegisterEffect(Fusion.CreateSummonEff(c,s.spfilter,Card.IsAbleToDeck,s.fextra,Fusion.ShuffleMaterial,nil,nil,nil,0,nil,FUSPROC_NOTFUSION|FUSPROC_LISTEDMATS))
end
s.listed_series={SET_ELEMENTAL_HERO}
s.listed_names={CARD_NEOS}
function s.spfilter(c)
	return c:IsSetCard(SET_ELEMENTAL_HERO) and c:ListsCodeAsMaterial(CARD_NEOS)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(aux.NecroValleyFilter(Fusion.IsMonsterFilter(Card.IsAbleToDeck)),tp,LOCATION_GRAVE,0,nil)
end