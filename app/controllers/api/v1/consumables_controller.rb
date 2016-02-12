class Api::V1::ConsumablesController < Api::V1::ApiController

  def query_params
    params.permit(:barcode)
  end

  def query_sort
    { created_at: :desc }
  end

end
