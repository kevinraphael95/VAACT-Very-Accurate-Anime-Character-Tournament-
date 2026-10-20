--[VAACT] Fusion de Figure
--Base : c29062925.lua (Face Card Fusion) - Scripted by Eerie Code
local s,id=GetID()

-- IDs regroupés en haut (custom VAACT + officiels)
local ID_REINE_VAACT=910000021
local ID_ROI_VAACT=910000031
local ID_VALET_VAACT=910000032

function s.initial_effect(c)
	--fusfilter=nil : n'importe quel Monstre Fusion (plus seulement LUMIERE Guerrier)
	local e1=Fusion.CreateSummonEff(c,nil,nil,s.fextra,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,s.extratg)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
s.listed_names={ID_REINE_VAACT,ID_ROI_VAACT,ID_VALET_VAACT,CARD_JACK_KNIGHT,CARD_QUEEN_KNIGHT,CARD_KING_KNIGHT}

function s.knightfilter(c)
	return c:IsFaceup() and c:IsCode(
		ID_REINE_VAACT,ID_ROI_VAACT,ID_VALET_VAACT,
		CARD_QUEEN_KNIGHT,CARD_KING_KNIGHT,CARD_JACK_KNIGHT)
end
function s.fextra(e,tp,mg)
	if Duel.IsExistingMatchingCard(s.knightfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		local sg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
		if #sg>0 then
			return sg,s.fcheck
		end
	end
	return nil
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end