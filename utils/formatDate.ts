import dayjs from 'dayjs'

/**
 * Get datetime string formatted ISO8601(YYYY-MM-DDTHH:mm:ss)
 *
 * @param dateString - Parsable string by dayjs
 */
export const convertDatetimeToISO8601Format = (dateString: string): string => {
  return dayjs(dateString).format('YYYY-MM-DDTHH:mm:ss')
}

/**
 * Get date string formatted ISO8601(YYYY-MM-DD)
 *
 * @param dateString- Parsable string by dayjs
 */
export const convertDateToISO8601Format = (dateString: string): string => {
  return dayjs(dateString).format('YYYY-MM-DD')
}

/**
 * @param dateString - Parsable string by dayjs
 * @param delimiter - default is '/'
 */
export const convertDateToNonZeroMonthAndDayFormat = (
  dateString: string,
  delimiter = '/'
): string => {
  return dayjs(dateString).format(`M${delimiter}D`)
}
